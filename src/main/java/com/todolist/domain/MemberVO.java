package com.todolist.domain;

import lombok.ToString;

import lombok.Setter;

import lombok.Getter;

import lombok.AllArgsConstructor;

import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class MemberVO {
	private String memberId;
	private String email;
	private String memberName;
}
