package junit.test;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Slf4jTest {

	public static void main(String[] args) {
		
		Logger log = LoggerFactory.getLogger(Slf4jTest.class);

		log.debug("debug级别日志");
		log.info("info级别日志");
		log.warn("warn级别日志");
		log.error("error级别日志");
		
		
	}

}
