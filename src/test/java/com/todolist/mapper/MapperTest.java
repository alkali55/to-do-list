package com.todolist.mapper;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.extern.slf4j.Slf4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/spring/**/root-context.xml"})
@Slf4j
public class MapperTest {
	
	@Autowired
	private TestMapper testMapper;
	
	@Autowired
	private MemberMapper memberMapper;
	
	@Test
	public void test1() {
		
		log.info("현재시간 : {}", testMapper.selectNow());
		
		log.info("중복? : {}", memberMapper.idDupCheck("qwer11"));
		
	}
}
