package com.todolist.controller.todo;

import java.time.LocalDate;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.todolist.domain.MemberVO;
import com.todolist.domain.ToDoDTO;
import com.todolist.service.todo.ToDoService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/toDo")
@RequiredArgsConstructor
public class ToDoController {
	
	private final ToDoService toDoService;
	
	
	
	@GetMapping("/register")
	public String registerGet(HttpSession session) {
		
		if(session.getAttribute("loginMember") == null) {
			return "redirect:/";
		}
		
		return "/toDo/register";
		
	}
	
	@PostMapping("/register")
	public String registerPost(@RequestParam("dueDateStr") String dueDateStr, ToDoDTO toDoDTO, HttpSession session) {
		
		if(session.getAttribute("loginMember") == null) {
			return "redirect:/";
		}
		
		String result = "fail";
		
		MemberVO loginMember = (MemberVO)session.getAttribute("loginMember");
		
		toDoDTO.setWriter(loginMember.getMemberId());
		toDoDTO.setDueDate(LocalDate.parse(dueDateStr));
		
		log.info("toDoDTO : {}", toDoDTO);
		
		if(toDoService.insertToDo(toDoDTO)) {
			result = "success";
		};
		
		log.info("결과 : {}", result);
		
		return "redirect:/";
	}
	
	@PostMapping("/list")
	public String toDoListGet(HttpSession session) {
		

		if(session.getAttribute("loginMember") == null) {
			return "redirect:/";
		}
		
		return "/toDo/list";
	}
	
}
