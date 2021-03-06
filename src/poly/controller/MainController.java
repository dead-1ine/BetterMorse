package poly.controller;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import poly.dto.MongoDTO;
import poly.persistance.mongo.IMongoTestMapper;
import poly.service.IUserService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Iterator;
import java.util.List;


@Controller
public class MainController {

	private Logger log = Logger.getLogger(this.getClass());

	@RequestMapping(value="index")
	public String Index() {
		log.info(this.getClass());
		return "/index";
	}

	@RequestMapping(value="/Home/MorseMain")
	public String GotoHome() {
		log.info(this.getClass().getName() + ".MorseHome Start!");
		return "/Home/MorseMain";
	}

	// 가장 기본이 되는 Home : 문자를 하나씩 사용자에게 모스부호와 함께 제공
	@RequestMapping(value="/Morse/MorseHome")
	public String main_basic() {
		log.info(this.getClass().getName() + ".MorseHome Start!");
		return "/Morse/MorseHome";
	}

	// 기본의 다음인 Basic : 단어의 형태로 만들 수 있게 함
	@RequestMapping(value="/Morse/MorseBasic")
	public String MorseBasic() {
		log.info(this.getClass().getName() + ".MorseBasic Start!");
		return "/Morse/MorseBasic";
	}
	
}
