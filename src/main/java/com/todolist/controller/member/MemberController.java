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

import com.todolist.domain.LoginDTO;
import com.todolist.domain.MemberDTO;
import com.todolist.domain.MemberVO;
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
	
	@PostMapping("/checkAuthCode")
	@ResponseBody
	public String checkAuthCode(String memberAuthCode ,HttpSession session) {
		
		String result = "false";
		
		String authCode = (String)session.getAttribute("authCode");
		
		if(authCode.equals(memberAuthCode)) {
			result = "true";
		}
		
		return result;
	}
	
	@PostMapping("/clearAuthCode")
	@ResponseBody
	public String clearAuthCode(HttpSession session) {
		
		if(session.getAttribute("authCode") != null) {
			
			session.removeAttribute("authCode");			
		}
		
		return "success";
	}
	
	@PostMapping("/signup")
	public String singupPost(MemberDTO memberDTO) {
		String result = "";
		
		log.info("memberDTO : {}", memberDTO);
		
		
		if(memberService.insertMember(memberDTO)) {
			result = "redirect:/member/login?signup=success";
		} else {
			result = "redirect:/member/signup";
		}
		
		return result;
	}
	
	@GetMapping("/login")
	public String loginGet() {
		return "/member/login";
	}
	
	@PostMapping("/login")
	public String loginPost(LoginDTO loginDTO, HttpSession session) {
		String result = "";
		MemberVO loginMember = memberService.loginMember(loginDTO);
		
		log.info("memberVO : {}", loginMember);
		
		if (loginMember != null) {
			session.setAttribute("loginMember", loginMember);
			result = "redirect:/";
		} else {
			result = "redirect:/member/login?login=fail";
		}
		
		return result;
	}
	
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.removeAttribute("loginMember");
		
		return "redirect:/";
	}
	
	@GetMapping("/mypage")
	public void myPage() {
		
	}
}
