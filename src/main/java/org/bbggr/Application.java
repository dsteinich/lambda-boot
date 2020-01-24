package org.bbggr;

import java.util.function.Function;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class Application {

	@Autowired
	ADao aDao;

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}

	@Bean
	public Function<Object, String> echoObject() {
		return value -> {
			System.out.println("Here's the input:");
			System.out.println(value.toString());
			int a = aDao.getRecordCount();
			System.out.println("Here's the count:");
			System.out.println(a);
			return "Hello" + value.toString() + a;
		};
	}
}
