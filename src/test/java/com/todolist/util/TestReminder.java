package com.todolist.util;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.todolist.domain.ToDoVO;
import com.todolist.mapper.MemberMapper;
import com.todolist.mapper.ToDoMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/spring/**/root-context.xml"})
public class TestReminder {
	
	@Autowired
	private ToDoMapper toDoMapper;
	
	@Autowired
	private SendMailService sendMailService;
	
	@Autowired
	private MemberMapper memberMapper;
	
	@Test
	public void reminderSchedule() throws AddressException, FileNotFoundException, IOException, MessagingException {

//		
//		log.info("list : {}", list);
		
		
		
		// 내일 마감인 글 조회
				List<ToDoVO> list = toDoMapper.selectToDoDueTomorrow();
				
				log.info("list : {}", list);
				
				// key : writer
				// value : 내일 마감인 글들
				Map<String, List<ToDoVO>> memberToDoMap = new HashMap<String, List<ToDoVO>>();
				
				for (ToDoVO vo : list) {
					
					if(!memberToDoMap.containsKey(vo.getWriter())) {
						memberToDoMap.put(vo.getWriter(), new ArrayList<ToDoVO>());
					}
					
					memberToDoMap.get(vo.getWriter()).add(vo);
				}
				
				for (Map.Entry<String, List<ToDoVO>> entry : memberToDoMap.entrySet()) {
					
					String memberId = entry.getKey();
//					log.info("writer : {} ", memberId);
//					log.info("list : {} ", entry.getValue());
					
					String email = memberMapper.selectEmailByMemberId(memberId);
//					log.info("email : {}", email);
					
					// 메일 본문
					StringBuilder sb = new StringBuilder();
					
					sb.append("안녕하세요. 내일까지 해야할 일이 있습니다.");
					
					for(ToDoVO vo : entry.getValue()) {
						sb.append("---").append(vo.getToDo());
					}
					
					sb.append(memberId + "님, 꼭 완료하세요!!!");
					
					log.info("내용 : {} ", sb.toString());
					
					sendMailService.sendReminder(email, sb.toString());
				}
	}
}
