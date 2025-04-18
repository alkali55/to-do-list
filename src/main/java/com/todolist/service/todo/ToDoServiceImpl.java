package com.todolist.service.todo;

import java.util.List;

import org.springframework.stereotype.Service;

import com.todolist.domain.ToDoDTO;
import com.todolist.domain.ToDoVO;
import com.todolist.mapper.ToDoMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ToDoServiceImpl implements ToDoService {
	
	private final ToDoMapper toDoMapper;
	
	@Override
	public boolean insertToDo(ToDoDTO toDoDto) {
		log.info("확인");
		
		boolean result = false;
		
		if(toDoMapper.insertToDo(toDoDto) == 1) {
			result = true;
		}
		
		return result;
	}

	@Override
	public List<ToDoVO> selectMyToDo(String memberId) {

		
		return toDoMapper.selectMyToDo(memberId);
	}

}
