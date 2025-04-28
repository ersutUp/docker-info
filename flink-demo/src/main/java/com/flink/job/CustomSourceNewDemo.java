package com.flink.job;

import com.alibaba.fastjson2.JSON;
import com.flink.dto.DataTest;
import org.apache.flink.api.connector.source.*;
import org.apache.flink.core.io.InputStatus;
import org.apache.flink.core.io.SimpleVersionedSerializer;
import java.io.*;
import java.util.*;
import java.util.concurrent.*;

/**
 * todo Ai生成的 具体怎么使用还不会
 */
public class CustomSourceNewDemo implements Source<String, CustomSourceNewDemo.MySplit, Void> {

    // 自定义Split（每个分片代表一个数据生成任务）
    public static class MySplit implements SourceSplit {
        private final String splitId;

        public MySplit(String splitId) {
            this.splitId = splitId;
        }

        @Override
        public String splitId() {
            return splitId;
        }
    }

    @Override
    public Boundedness getBoundedness() {
        return Boundedness.CONTINUOUS_UNBOUNDED;
    }

    @Override
    public SplitEnumerator<MySplit, Void> createEnumerator(SplitEnumeratorContext<MySplit> enumContext) {
        // 初始化时创建固定数量的分片（这里简化只创建1个分片）
        ArrayList<MySplit> mySplits = new ArrayList<>();
        mySplits.add(new MySplit("split-0"));
        return new MySplitEnumerator(mySplits, enumContext);
    }

    @Override
    public SplitEnumerator<MySplit, Void> restoreEnumerator(
            SplitEnumeratorContext<MySplit> enumContext,
            Void checkpoint) {
        // 从检查点恢复时重新创建分片
        return createEnumerator(enumContext);
    }

    @Override
    public SimpleVersionedSerializer<MySplit> getSplitSerializer() {
        return new MySplitSerializer();
    }

    @Override
    public SimpleVersionedSerializer<Void> getEnumeratorCheckpointSerializer() {
        return new VoidSerializer();
    }

    @Override
    public SourceReader<String, MySplit> createReader(SourceReaderContext readerContext) {
        return new MySourceReader();
    }

    // Split分配器
    private static class MySplitEnumerator implements SplitEnumerator<MySplit, Void> {
        private final List<MySplit> splits;
        private final SplitEnumeratorContext<MySplit> context;
        private final Set<Integer> registeredReaders = new HashSet<>();

        public MySplitEnumerator(List<MySplit> splits, SplitEnumeratorContext<MySplit> context) {
            this.splits = splits;
            this.context = context;
        }

        @Override
        public void start() {
            distributeSplits();
        }

        @Override
        public void addSplitsBack(List<MySplit> splits, int subtaskId) {
            this.splits.addAll(splits);
            distributeSplits();
        }
        @Override
        public void addReader(int subtaskId) {
            // 记录新注册的Reader
            registeredReaders.add(subtaskId);
            distributeSplits();
        }

        private void distributeSplits() {
            if (registeredReaders.isEmpty() || splits.isEmpty()) {
                return;
            }

            // 轮询分配分片给已注册的Reader
            List<Integer> subtasks = new ArrayList<>(registeredReaders);
            for (int i = 0; i < splits.size(); i++) {
                int targetSubtask = subtasks.get(i % subtasks.size());
                context.assignSplit(splits.get(i), targetSubtask);
            }
            splits.clear();
        }

        @Override
        public void handleSplitRequest(int subtaskId, String requesterHostname) {
            // 无动态分配需求
        }

        @Override
        public Void snapshotState(long checkpointId) {
            return null; // 无状态需要保存
        }

        @Override
        public void close() throws IOException {
            // 清理资源
        }

        @Override
        public void notifyCheckpointComplete(long checkpointId) throws Exception {
            SplitEnumerator.super.notifyCheckpointComplete(checkpointId);
        }

        @Override
        public void notifyCheckpointAborted(long checkpointId) throws Exception {
            SplitEnumerator.super.notifyCheckpointAborted(checkpointId);
        }

        @Override
        public void handleSourceEvent(int subtaskId, SourceEvent sourceEvent) {
            SplitEnumerator.super.handleSourceEvent(subtaskId, sourceEvent);
        }
    }

    // 数据读取器
    private static class MySourceReader implements SourceReader<String, MySplit> {
        private final BlockingQueue<String> buffer = new LinkedBlockingQueue<>();
        private CompletableFuture<Void> availabilityFuture = new CompletableFuture<>();
        private ScheduledExecutorService executor;

        @Override
        public void start() {
            // 启动定时数据生成任务
            executor = Executors.newSingleThreadScheduledExecutor();
            executor.scheduleAtFixedRate(() -> {
                DataTest data = new DataTest();
                data.setVal(new Random().nextInt(100));
                buffer.offer(JSON.toJSONString(data));
                // 有数据时唤醒主线程
                if (!availabilityFuture.isDone()) {
                    availabilityFuture.complete(null);
                }
            }, 0, 1, TimeUnit.SECONDS); // 每秒生成一条数据
        }

        @Override
        public InputStatus pollNext(ReaderOutput<String> output) {
            String data = buffer.poll();
            if (data != null) {
                output.collect(data);
                return buffer.isEmpty() ? InputStatus.NOTHING_AVAILABLE : InputStatus.MORE_AVAILABLE;
            } else {
                // 无数据时重置可用性Future
                availabilityFuture = new CompletableFuture<>();
                return InputStatus.NOTHING_AVAILABLE;
            }
        }

        @Override
        public List<MySplit> snapshotState(long checkpointId) {
            return Collections.emptyList(); // 不保存状态
        }

        @Override
        public CompletableFuture<Void> isAvailable() {
            return availabilityFuture;
        }

        @Override
        public void addSplits(List<MySplit> splits) {
            // 收到新分片（本示例不需要处理）
        }

        @Override
        public void notifyNoMoreSplits() {
        }

        @Override
        public void close() throws Exception {
            if (executor != null) {
                executor.shutdownNow();
            }
            buffer.clear();
        }
    }

    // Split序列化器
    private static class MySplitSerializer implements SimpleVersionedSerializer<MySplit> {
        @Override
        public int getVersion() {
            return 1;
        }

        @Override
        public byte[] serialize(MySplit split) throws IOException {
            try (ByteArrayOutputStream bos = new ByteArrayOutputStream();
                 DataOutputStream dos = new DataOutputStream(bos)) {
                dos.writeUTF(split.splitId());
                return bos.toByteArray();
            }
        }

        @Override
        public MySplit deserialize(int version, byte[] serialized) throws IOException {
            try (ByteArrayInputStream bis = new ByteArrayInputStream(serialized);
                 DataInputStream dis = new DataInputStream(bis)) {
                return new MySplit(dis.readUTF());
            }
        }
    }

    // 空状态序列化器
    private static class VoidSerializer implements SimpleVersionedSerializer<Void> {
        @Override public int getVersion() { return 1; }
        @Override public byte[] serialize(Void obj) { return new byte[0]; }
        @Override public Void deserialize(int version, byte[] serialized) { return null; }
    }
}