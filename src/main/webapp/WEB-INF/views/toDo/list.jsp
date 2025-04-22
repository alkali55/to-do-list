<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	

	

	let memoDataOrigin = [];
	let memoDataCopy = [];
	let finished = 0;
	let includePast = false;
	let sortBasis = "dueFast";
	let searchFilter = false;

	$(function(){
		callToDoList();
		decideCopyForShow();
		sortCopy();
		showToDoList();
		
		// 완료 여부에 따른 show 클릭 이벤트
		$(".for-show-by-finished").click(function(){
			$(".for-show-by-finished").removeClass("btn-primary");
			$(".for-show-by-finished").addClass("btn-outline-primary");
			$(this).addClass("btn-primary");
			$(this).removeClass("btn-outline-primary");
			
			finished = $(this).data("finished");
			
			
			decideCopyForShow();
			sortCopy();
			showToDoList();
		});

		// 마감된 일 show 클릭 이벤트
		$(".for-show-by-due").click(function(){


			if ($(this).hasClass("btn-outline-primary")){
				$(this).removeClass("btn-outline-primary");
				$(this).addClass("btn-primary");
				includePast = true;

			} else {
				$(this).addClass("btn-outline-primary");
				$(this).removeClass("btn-primary");
				includePast = false;
			}

			decideCopyForShow();
			sortCopy();
			showToDoList();
		});

		// 정렬 기준 클릭 이벤트
		$(".for-sort").click(function(){
			$(".for-sort").removeClass("btn-primary");
			$(".for-sort").addClass("btn-outline-primary");
			$(this).addClass("btn-primary");
			$(this).removeClass("btn-outline-primary");
			sortBasis = $(this).data("basis");

			decideCopyForShow();
			sortCopy();
			showToDoList();
		});

		// 검색필터
		$(".searchFilter").click(function(){
			if (!searchFilter){
				$(this).addClass("btn-primary");
				$(this).removeClass("btn-outline-primary");
				searchFilter = true;
			} else {
				$(this).removeClass("btn-primary");
				$(this).addClass("btn-outline-primary");
				searchFilter = false;
			}
		})

		// 필터 인풋태그 키업이벤트
		$("#inputFilter").keyup(function(){
			if(!searchFilter){
				return;
			}

			decideCopyForShow();
			sortCopy();
			showToDoList();
		})

		// 완료 여부 수정
		// $("body").on("change", ".finishedCheckbox", function(event){
			
		// 	event.stopPropagation();
		// 	let tno = $(this).data("tno");
		// 	let checked = $(this).is(":checked");

		// 	$.ajax({
		// 		url: '/toDo/updateFinished', // 데이터가 송수신될 서버의 주소
		// 		type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
		// 		dataType: "text", // 수신받을 데이터 타입 (MIME TYPE) (text, json, xml)
		// 		data: {
		// 			  "tno" : tno,
		// 			  "finished" : checked
		// 		  },  // 보내는 데이터
		// 		async: false, // 동기 통신 방식
		// 		success: function (data) {
		// 			// 통신이 성공하면 수행할 함수
		// 			console.log(data);
		// 			callToDoList();
				
				
		// 		},
		// 		error: function () {},
		// 		complete: function () {
		// 		},
		// 	});
		// })


		// toDo 수정
		$("body").on("click", ".toDoBox", function(){
			console.log($(this));

			if(!$(this).data("isModifying")){
				let tmpTnoMemo = $(this).prop("id");
				
				decideCopyForShow();
				sortCopy();
				showToDoList();

				// $("a").data("isModifying", false);
				$(`#\${tmpTnoMemo}`).data("isModifying", true);

				let toDoMemo = $(`#\${tmpTnoMemo}`).find(".toDo").text();
				let dueDateMemo = $(`#\${tmpTnoMemo}`).find(".dueDate").text();
				let tnoMemo = $(`#\${tmpTnoMemo}`).data("tno");
				let finishedMemo = $(`#\${tmpTnoMemo}`).find(".finishedCheckbox").is(":checked");
				
				console.log(toDoMemo, dueDateMemo, $(`#\${tmpTnoMemo}`).data("tno"), finishedMemo, tnoMemo);

				let modifyOutput = ``;
				modifyOutput += `<input type="hidden" value="\${tnoMemo}" name="tno">`;
				modifyOutput += `<input type="text" name="toDo" value="\${toDoMemo}" id="modifyTodo-tno-\${tnoMemo}">`;
				modifyOutput += `<input type="date" class="input-dueDate" name="dueDateStr" value="\${dueDateMemo}" id="modifyDueDate-tno-\${tnoMemo}">`;
				if (finishedMemo == true){
					modifyOutput += `<input type="checkbox" class="form-check-input finishedCheckbox" data-tno="\${tnoMemo}" checked> `;
				} else {
					modifyOutput += `<input type="checkbox" class="form-check-input finishedCheckbox" data-tno="\${tnoMemo}"> `;
				}
				modifyOutput += `<button type="submit" class="btn btn-primary modifyBtn" onclick="modifyTodo(this, \${tnoMemo})">등록</button>`;
				
				$(`#\${tmpTnoMemo}`).html(modifyOutput);
			}
		});

		
	});

	// toDo 날짜 유효성 검사
	function dueDateValid(dueDateVal){
		let dueDate = new Date(dueDateVal);
		let today = new Date();

		if(dueDate.getFullYear() > today.getFullYear() || 
			dueDate.getFullYear() == today.getFullYear() && dueDate.getMonth() > today.getMonth() ||
			dueDate.getFullYear() == today.getFullYear() && dueDate.getMonth() == today.getMonth() && dueDate.getDate() >= today.getDate() ){
			
				return true;
		}

		return false;
	}

	// toDo 길이 유효성 검사
	function toDoLengthValid(toDoVal){

		if (toDoVal.length <= 100){
			return true;
		}

		return false;
	}

	// toDo 유효성 검사 및 수정
	function modifyTodo(thisBtn, tno){
		// let toDoVal = $(thisBtn).prev().prev().prev().val();
		// let dueDateVal = $(thisBtn).prev().prev().val();

		let toDoVal = $(thisBtn).siblings(`#modifyTodo-tno-\${tno}`).val();
		let dueDateVal = $(thisBtn).siblings(`#modifyDueDate-tno-\${tno}`).val();
		let finishedVal = $(thisBtn).siblings(`.finishedCheckbox`).is(":checked");

		console.log(toDoVal, dueDateVal);

		let result = false;
		let toDoLengthValidCheck = toDoLengthValid(toDoVal);
		let dueDateValidCheck = dueDateValid(dueDateVal);
		
		if(toDoLengthValidCheck && dueDateValidCheck){

			$.ajax({
				url: '/toDo/modifyToDo', // 데이터가 송수신될 서버의 주소
				type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
				dataType: "text", // 수신받을 데이터 타입 (MIME TYPE) (text, json, xml)
				data: {
					  "tno" : tno,
					  "toDo" : toDoVal,
					  "dueDateStr" : dueDateVal,
					  "finished" : finishedVal
				  },  // 보내는 데이터
				async: false, // 동기 통신 방식
				success: function (data) {
					// 통신이 성공하면 수행할 함수
					console.log(data);
					
					location.reload(true);
				},
				error: function () {},
				complete: function () {
				},
			});
		}

	}

	// 카피본 정렬
	function sortCopy(){
		
		if (sortBasis == "dueFast"){

			for(let i = 0; i < memoDataCopy.length - 1; i++){
				for(let j = i + 1; j < memoDataCopy.length; j++){
					let iDate = new Date(memoDataCopy[i].dueDate);
					let jDate = new Date(memoDataCopy[j].dueDate);
					if(iDate - jDate > 0){
						let tmp = memoDataCopy[i];
						memoDataCopy[i] = memoDataCopy[j];
						memoDataCopy[j] = tmp;
					}
				}
			}

		} else if (sortBasis == "dueSlow"){

			for(let i = 0; i < memoDataCopy.length - 1; i++){
				for(let j = i + 1; j < memoDataCopy.length; j++){
					let iDate = new Date(memoDataCopy[i].dueDate);
					let jDate = new Date(memoDataCopy[j].dueDate);
					if(iDate - jDate < 0){
						let tmp = memoDataCopy[i];
						memoDataCopy[i] = memoDataCopy[j];
						memoDataCopy[j] = tmp;
					}
				}
			}

		} else if (sortBasis == "regFast"){

			for(let i = 0; i < memoDataCopy.length - 1; i++){
				for(let j = i + 1; j < memoDataCopy.length; j++){
					if(memoDataCopy[i].tno - memoDataCopy[j].tno > 0){
						let tmp = memoDataCopy[i];
						memoDataCopy[i] = memoDataCopy[j];
						memoDataCopy[j] = tmp;
					}
				}
			}

		} else {

			for(let i = 0; i < memoDataCopy.length - 1; i++){
				for(let j = i + 1; j < memoDataCopy.length; j++){
					if(memoDataCopy[i].tno - memoDataCopy[j].tno < 0){
						let tmp = memoDataCopy[i];
						memoDataCopy[i] = memoDataCopy[j];
						memoDataCopy[j] = tmp;
					}
				}
			}

		}
	}

	// 보여줄 toDoList 결정
	function decideCopyForShow(){

		memoDataCopy = [];

		if (finished == 0 && !includePast){
			$.each(memoDataOrigin, function(i, item){
				let remainDay = calculateRemainDay(item.dueDate);
				if(!item.finished && remainDay >= 0){
					memoDataCopy.push(item);
				}
			});

		} else if (finished == 0 && includePast){
			$.each(memoDataOrigin, function(i, item){
				if(!item.finished){
					memoDataCopy.push(item);
				}
			});

		} else if (finished == 1 && !includePast){
			$.each(memoDataOrigin, function(i, item){
				let remainDay = calculateRemainDay(item.dueDate);
				if(item.finished && remainDay >= 0){
					memoDataCopy.push(item);
				}
			});

		} else if (finished == 1 && includePast){
			$.each(memoDataOrigin, function(i, item){
				if(item.finished){
					memoDataCopy.push(item);
				}
			});

		} else if (finished == "all" && !includePast){
			$.each(memoDataOrigin, function(i, item){
				let remainDay = calculateRemainDay(item.dueDate);
				if(remainDay >= 0){
					memoDataCopy.push(item);
				}
			});

		} else {
			$.each(memoDataOrigin, function(i, item){
				memoDataCopy.push(item);
			});
		}

		if(searchFilter){
			memoDataCopy = memoDataCopy.filter(toDoDTO => {
				let searchWord = $("#inputFilter").val();
				return toDoDTO.toDo.includes(searchWord);
			})
		}

	}

	// dueDate까지의 날은 일수 계산
	function calculateRemainDay(dueDateParam){
		let dueDate = new Date (dueDateParam);
		let tmpday = new Date();
		let tmpStr = `\${tmpday.getFullYear()}-\${tmpday.getMonth() + 1}-\${tmpday.getDate()}`;
		let today = new Date(tmpStr);

		let remainDay = Math.floor((dueDate - today) / 1000 / 60 / 60 / 24);
		return remainDay;
	}

	// toDoList show
	function showToDoList(){
		let output = ``;
		$.each(memoDataCopy, function(i, item){
			
			let remainDay = calculateRemainDay(item.dueDate);

			if (item.finished == true){
				output += `<a href="#" class="list-group-item list-group-item-action list-group-item-success toDoBox" id="tno-\${item.tno}" data-tno="\${item.tno}" data-isModifying="false">`;
			} else if (remainDay >= 0 && remainDay <= 3){
				output += `<a href="#" class="list-group-item list-group-item-action list-group-item-danger toDoBox" id="tno-\${item.tno}" data-tno="\${item.tno}" data-isModifying="false">`;
			} else if (remainDay < 0){
				output += `<a href="#" class="list-group-item list-group-item-action list-group-item-secondary toDoBox" id="tno-\${item.tno}" data-tno="\${item.tno}" data-isModifying="false">`;
			} else {
				output += `<a href="#" class="list-group-item list-group-item-action toDoBox" id="tno-\${item.tno}" data-tno="\${item.tno}" data-isModifying="false">`;
			}
				
			output += `<span class="toDo">\${item.toDo} </span> <span class="dueDate">\${item.dueDate}</span>`;

			if (item.finished == true){
				output += `<input type="checkbox" class="form-check-input finishedCheckbox" data-tno="\${item.tno}" checked> `;
			} else {
				output += `<input type="checkbox" class="form-check-input finishedCheckbox" data-tno="\${item.tno}"> `;
			}

			
			output += `</a>`;
		});

		
		
		$("#toDoBox").html(output);
	}

	// toDoList ajax 호출
	function callToDoList(){

		$.ajax({
	        url: '/toDo/list', // 데이터가 송수신될 서버의 주소
	        type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
	        dataType: "json", // 수신받을 데이터 타입 (MIME TYPE) (text, json, xml)
	        async: false, // 동기 통신 방식
	        success: function (data) {
	          // 통신이 성공하면 수행할 함수
			  memoDataOrigin = data;
	          console.log(memoDataOrigin);
	          
	          
	        },
	        error: function () {},
	        complete: function () {
	        },
	  	});

	}
	

</script>
<style>
	#aa {
		margin-top : 20px;
		margin-bottom : 20px;
	}
	.finishedCheckbox {
		margin-left: 20px;
		margin-right: 20px;
	}
	.dueDate {
		margin-left: 20px;
	}
	#for-sort-div{
		padding-left: 0px;
		margin-top: 20px;
	}
	.input-dueDate{
		margin-left: 20px;
	}
</style>
<body>
	<jsp:include page="../header.jsp"></jsp:include>
	<div class="container mt-5">
		<div class="row">
		
			<h1>ToDoList</h1>
			
			
			
			<div id="for-sort-div">
				<ul class="list-group">
					<li class="list-group-item">
						완료 여부 : 
						<button type="button" class="btn for-show-by-finished btn-primary" data-finished="0">미완료한 일만</button>
						<button type="button" class="btn btn-outline-primary for-show-by-finished" data-finished="1">완료한 일만</button>
						<button type="button" class="btn btn-outline-primary for-show-by-finished" data-finished="all">모두</button>
					</li>
					<li class="list-group-item">
						지나간 일 포함 여부 : 
						<button type="button" class="btn btn-outline-primary for-show-by-due">지나간 일 포함</button>
					</li>
					<li class="list-group-item">
						정렬 기준 : 
						<button type="button" class="btn for-sort btn-primary" data-basis="dueFast">마감일 빠른 기준</button>
						<button type="button" class="btn btn-outline-primary for-sort" data-basis="dueSlow">마감일 느린 기준</button>
						<button type="button" class="btn btn-outline-primary for-sort" data-basis="regFast">작성일 빠른 기준</button>
						<button type="button" class="btn btn-outline-primary for-sort" data-basis="regSlow">작성일 느린 기준</button>
					</li>
					<li class="list-group-item">
						<div class="input-group mb-3">
							<button class="btn btn-outline-primary searchFilter" type="submit">검색필터켜기</button>
							<input type="text" class="form-control" placeholder="Search" id="inputFilter">
						</div>
					</li>
				  </ul>
			</div>

			<h4 id="aa">클릭으로 수정</h4>

			<div class="list-group" id="toDoBox">

			</div>		
		</div>
	</div>
	<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>