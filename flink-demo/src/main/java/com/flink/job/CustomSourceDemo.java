package com.flink.job;

import com.alibaba.fastjson2.JSON;
import com.flink.dto.DataTest;
import org.apache.flink.streaming.api.functions.source.SourceFunction;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.Serializable;
import java.util.Random;

public class CustomSourceDemo implements SourceFunction<String>, Serializable {
    private static final Logger logger = LoggerFactory.getLogger(CustomSourceDemo.class);

    boolean isCancel = false;

    @Override
    public void run(SourceContext<String> ctx) throws Exception {

        Runnable runnable = () -> {
            DataTest dataTest = new DataTest();
            dataTest.setVal(new Random().nextInt(100));
            ctx.collect(JSON.toJSONString(dataTest));
        };
        new Thread(runnable).start();

        do {
            Thread.sleep(50);
        } while (!isCancel);
    }

    @Override
    public void cancel() {
        isCancel = true;
        logger.info("Job cancel");
    }

}
