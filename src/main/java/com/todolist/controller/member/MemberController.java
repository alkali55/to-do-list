package com.todolist.controller.member;

import java.io.IOException;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.todolist.service.member.MemberService;
import com.todolist.util.SendMailService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {
	
	private final MemberService memberService;
	
	private final SendMailService sendMailService;

	
	@GetMapping("/signup")
	public String signupGet() {
		
		return "/member/signup";
		
	}
	
	@ResponseBody
	@PostMapping("/isDuplicate")
	public String isDuplicateId(@RequestParam("tmpMemberId") String tmpMemberId) {
		
		log.info("tmpMemberId : {}", tmpMemberId);
		
		String result = memberService.isDupId(tmpMemberId);
		
		log.info(result);
		
		return result;
	}
	
	@PostMapping("/callSendMail")
	@ResponseBody
	public String sendMailCode(String tmpMemberEmail, HttpSession session) {
		
		log.info("tmpMemberEmail : {}" , tmpMemberEmail);
		
		String result = "";
		
		String authCode = UUID.randomUUID().toString();
		log.info("authCode : {} ", authCode);
		
		try {
			sendMailService.sendMail(tmpMemberEmail, authCode); // 메일 전송
			
			session.setAttribute("authCode", authCode); // 인증코드를 세션객체에 저장 
			result = "success";
			
		} catch (IOException | MessagingException e) {
			e.printStackTrace();
			result = "fail";
		}
		
		return result;
	}
	
	@PostMapping("/signup")
	public void tmppp() {
		log.info("tmpp");
	}
}
