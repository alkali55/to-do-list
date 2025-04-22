package com.todolist.service.member;

import com.todolist.domain.LoginDTO;
import com.todolist.domain.MemberDTO;
import com.todolist.domain.MemberVO;

public interface MemberService {
	
	String isDupId(String tmpMemberId);

	boolean insertMember(MemberDTO memberDTO);

	MemberVO loginMember(LoginDTO loginDTO);

	String isDupEmail(String tmpEmail);
}
