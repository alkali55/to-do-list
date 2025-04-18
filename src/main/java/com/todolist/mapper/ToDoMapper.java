package com.todolist.mapper;

import java.util.List;

import com.todolist.domain.ToDoDTO;
import com.todolist.domain.ToDoVO;

public interface ToDoMapper {
	
	int insertToDo(ToDoDTO toDoDTO);

	List<ToDoVO> selectMyToDo(String memberId);
	
}
