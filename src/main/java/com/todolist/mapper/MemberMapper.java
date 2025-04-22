package com.todolist.mapper;

import com.todolist.domain.LoginDTO;
import com.todolist.domain.MemberDTO;
import com.todolist.domain.MemberVO;

public interface MemberMapper {
	
	String selectNow();
	
	int idDupCheck(String tmpMemberId);

	int insertMember(MemberDTO memberDTO);

	MemberVO loginMember(LoginDTO loginDTO);
	
	String selectEmailByMemberId(String memberId);

	int emailDupCheck(String tmpEmail);
}
