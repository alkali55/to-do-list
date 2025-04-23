package com.todolist.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.todolist.domain.ToDoDTO;
import com.todolist.domain.ToDoVO;

public interface ToDoMapper {
	
	int insertToDo(ToDoDTO toDoDTO);

	List<ToDoVO> selectMyToDo(String memberId);

	int updateFinished(@Param("tno")int tno, @Param("finished")boolean finished);

	int modifyToDo(ToDoDTO toDoDTO);

	List<ToDoVO> selectToDoDueTomorrow();

	List<ToDoVO> selectNotFinishedList(String memberId);

	int deleteToDo(String tno);
	
}
