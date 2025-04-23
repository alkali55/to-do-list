package com.todolist.service.member;

import org.springframework.stereotype.Service;

import com.todolist.domain.LoginDTO;
import com.todolist.domain.MemberDTO;
import com.todolist.domain.MemberVO;
import com.todolist.mapper.MemberMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
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


	@Override
	public boolean insertMember(MemberDTO memberDTO) {
		boolean result = false;
		
		if(memberMapper.insertMember(memberDTO) == 1) {
			result = true;
		}
		
		return result;
	}


	@Override
	public MemberVO loginMember(LoginDTO loginDTO) {
		
		return memberMapper.loginMember(loginDTO);
	}


	@Override
	public String isDupEmail(String tmpEmail) {
		String result = "";
		
		if(memberMapper.emailDupCheck(tmpEmail) == 1) {
			result = "true";
		} else {
			result = "false";
		}
		return result;
	}


	@Override
	public boolean modifyMyInformation(MemberDTO memberDTO) {
		boolean result = false;
		if(memberMapper.modifyMyInformation(memberDTO) == 1) {
			result = true;
		};
		
		return result;
	}


	@Override
	public boolean deleteMember(String memberId) {
		boolean result = false;
		if(memberMapper.deleteMember(memberId) == 1) {
			result = true;
		};
		return result;
		
	}

}
