package com.todolist.service.member;

import org.springframework.stereotype.Service;

import com.todolist.mapper.MemberMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {
	
	private final MemberMapper memberMapper;
	
	
	@Override
	public String isDupId(String tmpMemberId) {
		
		String result = "";
		
		if(memberMapper.idDupCheck(tmpMemberId) == 1) {
			result = "true";
		} else {
			result = "false";
		}
		
		return result;
	}

}
