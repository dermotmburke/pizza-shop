package io.contino.pizza.shop.transformer.config;

import io.contino.pizza.shop.transformer.properties.ServiceProperties;
import io.contino.pizza.shop.transformer.topologies.TopologyService;
import org.apache.kafka.clients.admin.NewTopic;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.KafkaStreams;
import org.apache.kafka.streams.StreamsConfig;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.TopicBuilder;
import org.springframework.kafka.support.serializer.JacksonJsonDeserializer;
import org.springframework.kafka.support.serializer.JacksonJsonSerde;

import java.util.Properties;

@Configuration
@EnableKafka
public class Config {

    @Value(value = "${spring.kafka.bootstrap-servers}")
    String bootstrapAddress;

    @Value("${spring.application.name}")
    String applicationName;

    @Bean
    KafkaStreams kafkaStreams(TopologyService topologyService) {
        Properties props = new Properties();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapAddress);
        props.put(StreamsConfig.APPLICATION_ID_CONFIG, applicationName);
        props.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());
        props.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, JacksonJsonSerde.class);
        props.put(JacksonJsonDeserializer.TRUSTED_PACKAGES, "*");
        KafkaStreams kafkaStreams = new KafkaStreams(topologyService.topology(), props);
        Runtime.getRuntime().addShutdownHook(new Thread(kafkaStreams::close));
        kafkaStreams.start();
        return kafkaStreams;
    }

    @Bean
    NewTopic inputTopic(ServiceProperties serviceProperties) {
        return TopicBuilder.name(serviceProperties.inbound().topic().topicName()).build();
    }

    @Bean
    NewTopic outputTopic(ServiceProperties serviceProperties) {
        return TopicBuilder.name(serviceProperties.outbound().topic().topicName()).build();
    }
}
