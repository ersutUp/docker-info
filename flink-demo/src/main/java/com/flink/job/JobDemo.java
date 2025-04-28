package com.flink.job;


import com.alibaba.fastjson2.JSONObject;

import com.flink.dto.*;

import org.apache.flink.api.common.eventtime.WatermarkStrategy;
import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.datastream.DataStreamSource;

import org.apache.flink.streaming.api.datastream.SingleOutputStreamOperator;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.functions.ProcessFunction;
import org.apache.flink.streaming.api.functions.sink.SinkFunction;
import org.apache.flink.util.Collector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.Serializable;


// Flink作业
public class JobDemo implements Serializable {
    private static final Logger logger = LoggerFactory.getLogger(JobDemo.class);

    public static void main(String[] args) throws Exception {
        run();
    }

    public static void run() throws Exception {


        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        env.setParallelism(2);

//        DataStreamSource<String> dataStreamSource = env.addSource(new CustomSourceDemo());
        DataStreamSource<String> dataStreamSource = env.fromSource(new CustomSourceNewDemo(), WatermarkStrategy.noWatermarks(),"CustomSourceNewDemo");

        SingleOutputStreamOperator<DataTest> stringSingleOutputStreamOperator = dataStreamSource.flatMap(
                new FlatMapFunction<String, DataTest>() {
                    @Override
                    public void flatMap(String value, Collector<DataTest> out) throws Exception {
                        out.collect(JSONObject.parseObject(value,DataTest.class));
                    }
                }
        );


        DataStream<Boolean> processedStream = stringSingleOutputStreamOperator.process(
                new ProcessFunction<>() {


                    @Override
                    public void processElement(DataTest data, Context context, Collector<Boolean> out) {
                        long startTime = System.currentTimeMillis();

                        boolean b = data.getVal() > 50;

                        long end = System.currentTimeMillis();
                        // 计算执行时间
                        logger.info("时间：" + end + "；执行时长：" + (end - startTime) + " 毫秒.");

                        out.collect(b);
                    }
                }

        );

        processedStream.addSink(new SinkFunction<>() {
            @Override
            public void invoke(Boolean value, Context context) throws Exception {
                logger.info("#########  数据  #########：" + value);
            }
        });

        processedStream.print();
        env.execute("Flink Demo");
    }
}
