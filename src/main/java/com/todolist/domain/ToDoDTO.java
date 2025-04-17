package com.todolist.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class ToDoDTO {
	
	private int tno;
	private String toDo;
	private Date dueDate;
	private String writer;
	private boolean finished;
}
