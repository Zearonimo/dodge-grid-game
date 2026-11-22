# dodge-grid-game 작업 기록

> 기록 전용: 통째로 읽지 말고 ID로 검색한다. 끝에 추가만 한다. 작업 ID는 C-YYMMDD-DGNN.

## 오류 (새 오류는 이 섹션 끝에 추가)
- E-DG01 첫 main 빌드 실패 `Cannot export project with preset "Web" due to configuration errors` (이유 줄은 비어 있음). 원인: Web 프리셋 `vram_texture_compression/for_mobile=true`인데 project.godot에 `import_etc2_astc` 없음 → `rendering/textures/vram_compression/import_etc2_astc=true` 추가로 해결 (PR #1). `libfontconfig` ERROR 줄은 무해

## 작업 기록
- C-261122-G01 🟡 연동 환경 파일 세팅 (Godot 4.7.2, mobile_desktop_sync_SETUP.md 기준). git init -b main, CLAUDE.md(연동 규칙+Godot 규칙), README, .gitignore/.gitattributes/.editorconfig, project.godot, scenes/main.tscn, scripts/main.gd(6x6 격자), export_presets.cfg(Web, 스레드 끔), .github/workflows/pages.yml(barichello/godot-ci:4.7.2로 PR 빌드 확인·main은 Pages 배포). 커밋·원격·push 안 함 (저장소 이름·공개 여부·git 사용자 정보·gh 대기). 실행 확인 안 함. (2026-11-22 세션 M이 Game\records\game_log.md에서 옮김)
- C-261122-DG00 ✅ (세션 M) 프로젝트 독립 환경으로 재구성: STATE.md·records\·.local\(test_outputs, tmp)을 이 저장소 안으로, .gitignore에 .local/ 추가, CLAUDE.md에 상태·기록·공통 원칙 추가
- C-261122-DG01 ✅ git `--local` user.name=Zearonimo, user.email=GitHub noreply 주소로 설정. gh 2.105.0 설치·로그인 확인(계정 Zearonimo, scopes repo·workflow). 이 세션 PATH엔 gh가 아직 없음 → `C:\Program Files\GitHub CLI\gh.exe` 전체 경로로 씀
- C-261122-DG02 🟡 GitHub 저장소 Zearonimo/dodge-grid-game(public) 생성, 첫 커밋 5cbb228 main push, Pages build_type=workflow 켬. 첫 빌드 실패(E-DG01) → 브랜치 fix/web-export-etc2, PR https://github.com/Zearonimo/dodge-grid-game/pull/1 의 export 체크 통과. main 합치기·Pages 배포·폰 확인 남음. 바뀐 파일: README.md(플레이 링크), project.godot
- C-261122-DG03 ✅ PR #1 merge(2defd9d), main 실행 45023322303 export·deploy 성공 → https://zearonimo.github.io/dodge-grid-game/ 배포됨. 페이지 화면은 아직 안 봄(사용자 폰 확인 대기)
- C-261122-DG04 🟡 게임 기본 구조: scripts/board.gd·player.gd·hazards.gd(돌·레이저·폭탄)·ui.gd 추가, main.gd 재작성(상태·스와이프/방향키·난이도·최고 기록 user://save.cfg, `-- --smoke` 자동 플레이). pages.yml에 Smoke run 단계, CLAUDE.md에 점검·코드 구조. PR https://github.com/Zearonimo/dodge-grid-game/pull/3 (PR #2 커밋 포함) CI 통과: SMOKE 로그 "game over at 15.1", 스크립트 오류 없음. 실제 화면·조작감은 안 봄
