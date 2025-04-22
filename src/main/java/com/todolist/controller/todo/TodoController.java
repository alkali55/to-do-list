package com.todolist.controller.todo;

import java.time.LocalDate;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.todolist.domain.MemberVO;
import com.todolist.domain.ToDoDTO;
import com.todolist.domain.ToDoVO;
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
		
//		log.info("toDoDTO : {}", toDoDTO);
		
		if(toDoService.insertToDo(toDoDTO)) {
			result = "success";
		};
		
//		log.info("결과 : {}", result);
		
		return "redirect:/";
	}
	
	@GetMapping("/list")
	public String toDoListGet(HttpSession session) {

		if(session.getAttribute("loginMember") == null) {
			return "redirect:/";
		}
		
		return "/toDo/list";
	}
	
	@PostMapping("/list")
	@ResponseBody
	public List<ToDoVO> toDoListPost(HttpSession session) {
		
		
		String memberId = ((MemberVO)session.getAttribute("loginMember")).getMemberId();
		
		List<ToDoVO> list = toDoService.selectMyToDo(memberId);
		
//		for(ToDoVO toDo : list) {
//			log.info("toDo : {}", toDo);
//		}
		
		
		return list;
	}
	
	@PostMapping("/updateFinished")
	@ResponseBody
	public String updateFinished(int tno, boolean finished) {
		String result = "fail";
		
		if(toDoService.updateFinished(tno, finished)) {
			result = "success";
		}
		
		
//		log.info("result : {}", result);
		return result;
		
	}
	
	@PostMapping("/modifyToDo")
	@ResponseBody
	public String modifyToDo(ToDoDTO toDoDTO, String dueDateStr, HttpSession session) {
		String result = "fail";
		
		toDoDTO.setDueDate(LocalDate.parse(dueDateStr));
		
		if(toDoService.modifyToDo(toDoDTO)) {
			result = "success";
		};
		
		return result;
		
	}
	
	@PostMapping("/notFinishedList")
	@ResponseBody
	public List<ToDoVO> selectNotFinishedList(HttpSession session) {
		
		
		String memberId = ((MemberVO)session.getAttribute("loginMember")).getMemberId();
		
		List<ToDoVO> list = toDoService.selectNotFinishedList(memberId);
		
//		for(ToDoVO toDo : list) {
//			log.info("toDo : {}", toDo);
//		}
		
		
		return list;
	}
}
