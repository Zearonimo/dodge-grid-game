# Dodge Grid

격자 위에서 날아오는 장애물을 피하는 반응속도 게임 (Godot 4.7.2).

- **플레이 링크:** https://zearonimo.github.io/dodge-grid-game/
- **조작:** 스와이프, 또는 방향키

## 이 PC에서 작업하기
```powershell
cd C:\AI\Game\dodge-grid-game
git checkout main; git pull
claude
```
Claude Code를 실행하면 `CLAUDE.md` 규칙(pull로 시작, push·PR로 끝)이 자동으로 적용된다.

## 모바일(클라우드)에서 작업하기
폰의 Claude 앱에서 Claude Code를 열고, GitHub 계정을 연결한 뒤 이 저장소로 새 세션을 만든다. 클라우드 세션도 `CLAUDE.md`를 읽는다. 클라우드에는 Godot 에디터가 없으므로 PR의 GitHub Actions 결과로 빌드를 확인한다.

## 실행하기
- **에디터:** Godot 4.7.2로 `project.godot`를 열고 F5를 누른다.
- **웹 빌드:** 에디터에서 프로젝트 → 내보내기 → Web으로 `build/web/`에 내보낸 뒤, 그 폴더를 로컬 서버로 띄우고 `http://localhost:8000`을 연다 (파일을 더블클릭해서 열면 동작하지 않는다).
