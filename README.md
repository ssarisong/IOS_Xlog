# Xlog💪🏻
### <iOS 운동 관리 애플리케이션 프로젝트>
- iOS 프로그래밍 D반 2071361 송수진🙍🏻‍♀️

## 1. 프로젝트 개요📡
이 프로젝트는 사용자의 운동 패턴 관리를 도와주는 애플리케이션이다. </br>
사용자가 한 운동 종류 및 날짜, 시간과 함께 운동 일지를 기록할 수 있고, 이 기록한 데이터를 그래프와 표로 한눈에 볼 수 있다. </br>
그리고, 오늘의 운동 스케줄이나 준비물 같은 것을 기록하고 관리할 수 있는 운동 Todo List와 운동 루틴 메모가 있다. </br>
<mark>※ Xcode에서 해당 프로젝트를 실행하기 위해선 `Xlog.xcodeproj`가 아닌 `Xlog.xcworkspace`를 실행해야 합니다.<mark>

## 2. 시연 영상🎥
https://youtu.be/ZGdpcMDtOAw

## 3. 결과물📸
### 3-1. 운동 기록 추가 화면 </br></br>
  - 초기 화면</br>
  <img width="373" alt="추가 초기 사진" src="https://github.com/ssarisong/IOS_Xlog/assets/107747359/fde33f84-cb45-46e2-887f-f9aa36e11e4d"> </br></br>
  - 입력 화면</br>
  <img width="373" alt="추가 입력 사진" src="https://github.com/ssarisong/IOS_Xlog/assets/107747359/aaa695e8-3535-4e13-b398-f9e9579733ee"></br>

### 3-2. 운동 기록 확인 화면</br></br>
  - 추가한 기록 확인 화면</br>
  <img width="373" alt="보기 사진" src="https://github.com/ssarisong/IOS_Xlog/assets/107747359/16a75365-1cd1-442c-965f-d7a350969ed0"></br></br>
  - 기록 삭제 화면 - 기록을 왼쪽으로 스와이프 했을 때</br>
  <img width="373" alt="보기 삭제 화면" src="https://github.com/ssarisong/IOS_Xlog/assets/107747359/c2042be4-8bdf-426e-82b8-84d12b65fdb9"></br>

### 3-3. 운동 Todo List 화면
  - Todo List 입력 화면</br>
  <img width="373" alt="투두 입력" src="https://github.com/ssarisong/IOS_Xlog/assets/107747359/367429bf-2745-4966-958a-314559ae8ea4"></br></br>
  - Todo List 삭제 화면 - 기록을 왼쪽으로 스와이프 했을 때</br>
  <img width="373" alt="투두 삭제" src="https://github.com/ssarisong/IOS_Xlog/assets/107747359/9dac68e6-9a54-465f-b5b5-dfd1447933b8"></br>

### 3-4. 운동 루틴 메모 화면
  - 운동 루틴 메모 입력 화면</br>
    <img width="373" alt="루틴 메모" src="https://github.com/ssarisong/IOS_Xlog/assets/107747359/379f196f-1b93-4f53-afc6-87e41161379e"></br>

## 4. 기능 설명🕹️
### 4-1. 데이터 관리
애플리케이션을 사용하면서 생성되는 운동 기록, Todo List, 루틴 메모 데이터는 `DataManager`를 사용하여 관리하고 init()에서 private로 전체 데이터를 초기화하여 `싱글톤 패턴`으로 관리한다.</br>
이를 통해 생성된 데이터가 애플리케이션을 재시작하더라도 사라지지 않고 남아있을 수 있다.

### 4-2. 차트 생성
`DGChart`라이브러리를 `cocoapods`를 이용하여 설치 후 사용한다.</br>
사용자의 운동 시간을 운동 종류에 따라 나눠서 누적 막대그래프로 표현하여 하루 중 가장 많이 운동한 운동 종류도 확인할 수 있고, 일주일 중 운동을 가장 많이 한 날도 확인할 수 있다.

### 4-3. TableView 사용
운동 기록 조회 페이지에서는 운동을 시작한 날짜를 내림차순하여 최근에 운동한 기록부터 보여준다.</br>
해당 운동이 차트에서 무슨 색으로 표시되고 있는지 확인하기 좋게 하기 위하여 cell의 맨 앞에 해당 운동의 차트에서 나오는 색을 작은 네모 블럭으로 표현한다.</br>
Todo List에서는 맨 앞에 check box를 추가하여 해당 Todo를 완료했는지 표시할 수 있다.</br>
모든 TableView에는 edgeStyle을 받아서 오른쪽에서 왼쪽으로 스와이프하면 delete 메뉴가 나오게 되고, 이 이벤트가 실행되면 해당하는 데이터가 DataManager에서 지워진다.</br>
