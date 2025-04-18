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
	

	// 디폴트 = 완료된 일 빼고 보기 
	// 완료된 일까지 보기 추가
	// 지나간 날짜 보기는 디폴트?
	// 마감일 기준 정렬, 작성일 기준 정렬 추가

	let memoDataOrigin = [];
	let memoDataCopy = [];
	let finished = 0;
	let includePast = false;
	let sortBasis = "dueFast";

	$(function(){
		callToDoList();
		decideCopyForShow();
		sortCopy();
		showToDoList();

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

		$(".for-show-by-due").click(function(){

			memoDataCopy = [];

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

		$(".for-sort").click(function(){
			$(".for-sort").removeClass("btn-primary");
			$(".for-sort").addClass("btn-outline-primary");
			$(this).addClass("btn-primary");
			$(this).removeClass("btn-outline-primary");
			sortBasis = $(this).data("basis");

			sortCopy();
			showToDoList();
		});

	});

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
				let remainDay = calculateRemainDay(item);
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
				let remainDay = calculateRemainDay(item);
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
				let remainDay = calculateRemainDay(item);
				if(remainDay >= 0){
					memoDataCopy.push(item);
				}
			});

		} else {
			$.each(memoDataOrigin, function(i, item){
				memoDataCopy.push(item);
			});
		}

		
	}

	// dueDate까지의 날은 일수 계산
	function calculateRemainDay(item){
		let dueDate = new Date (item.dueDate);
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
			
			let remainDay = calculateRemainDay(item);

			if (item.finished == true){
				output += `<a href="#" class="list-group-item list-group-item-action list-group-item-success" id="tno-\${item.tno}" data-tno="\${item.tno}>`;
			} else if (remainDay >= 0 && remainDay <= 3){
				output += `<a href="#" class="list-group-item list-group-item-action list-group-item-danger" id="tno-\${item.tno}" data-tno="\${item.tno}>`;
			} else if (remainDay < 0){
				output += `<a href="#" class="list-group-item list-group-item-action list-group-item-secondary" id="tno-\${item.tno}" data-tno="\${item.tno}>`;
			} else {
				output += `<a href="#" class="list-group-item list-group-item-action" id="tno-\${item.tno}" data-tno="\${item.tno}>`;
			}
				
			output += `<span id="toDo">\${item.toDo} </span><span id="dueDate">\${item.dueDate}</span>`;

			if (item.finished == true){
				output += `<input type="checkbox" class="form-check-input finishedCheckbox" data-tno="\${item.tno}" checked `;
			} else {
				output += `<input type="checkbox" class="form-check-input finishedCheckbox" data-tno="\${item.tno}" `;
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
	}
	#dueDate {
		margin-left: 20px;
	}
	#for-sort-div{
		padding-left: 0px;
		margin-top: 20px;
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