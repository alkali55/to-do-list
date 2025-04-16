package com.todolist.mapper;

public interface MemberMapper {
	
	String selectNow();
	
	int idDupCheck(String tmpMemberId);
	
}
