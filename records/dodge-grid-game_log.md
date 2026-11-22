# dodge-grid-game 작업 기록

> 기록 전용: 통째로 읽지 말고 ID로 검색한다. 끝에 추가만 한다. 작업 ID는 C-YYMMDD-DGNN.

## 오류 (새 오류는 이 섹션 끝에 추가)

## 작업 기록
- C-261122-G01 🟡 연동 환경 파일 세팅 (Godot 4.7.2, mobile_desktop_sync_SETUP.md 기준). git init -b main, CLAUDE.md(연동 규칙+Godot 규칙), README, .gitignore/.gitattributes/.editorconfig, project.godot, scenes/main.tscn, scripts/main.gd(6x6 격자), export_presets.cfg(Web, 스레드 끔), .github/workflows/pages.yml(barichello/godot-ci:4.7.2로 PR 빌드 확인·main은 Pages 배포). 커밋·원격·push 안 함 (저장소 이름·공개 여부·git 사용자 정보·gh 대기). 실행 확인 안 함. (2026-11-22 세션 M이 Game\records\game_log.md에서 옮김)
- C-261122-DG00 ✅ (세션 M) 프로젝트 독립 환경으로 재구성: STATE.md·records\·.local\(test_outputs, tmp)을 이 저장소 안으로, .gitignore에 .local/ 추가, CLAUDE.md에 상태·기록·공통 원칙 추가
- C-261122-DG01 ✅ git `--local` user.name=Zearonimo, user.email=GitHub noreply 주소로 설정. gh 2.105.0 설치·로그인 확인(계정 Zearonimo, scopes repo·workflow). 이 세션 PATH엔 gh가 아직 없음 → `C:\Program Files\GitHub CLI\gh.exe` 전체 경로로 씀
