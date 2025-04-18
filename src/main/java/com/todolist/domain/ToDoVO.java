package com.todolist.domain;



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
public class ToDoVO {
	
	private int tno;
	private String toDo;
	private String dueDate;
	private String writer;
	private boolean finished;
}
