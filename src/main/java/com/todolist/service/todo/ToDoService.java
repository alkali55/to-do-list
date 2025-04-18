package com.todolist.service.todo;

import java.util.List;

import com.todolist.domain.ToDoDTO;
import com.todolist.domain.ToDoVO;

public interface ToDoService {
	
	boolean insertToDo(ToDoDTO toDoDto);

	List<ToDoVO> selectMyToDo(String memberId);
}
