package com.todolist.controller.todo;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.todolist.domain.ToDoDTO;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/toDo")
public class TodoController {
	
	@GetMapping("/register")
	public String registerGet(HttpSession session) {
		
		if(session.getAttribute("loginMember") == null) {
			return "redirect:/";
		}
		
		return "/toDo/register";
		
	}
	
	@PostMapping("/register")
	public void registerPost(ToDoDTO toDoDTO) {
		
		log.info("toDoDTO : {}", toDoDTO);
		
		
	}
	
}
