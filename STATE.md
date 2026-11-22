# dodge-grid-game STATE (덮어쓰기)
> 갱신 2026-11-22 · 마지막 작업 C-261122-DG01 · 코드 DG
> gh 로그인됨(Zearonimo). 이 PC 세션에선 `C:\Program Files\GitHub CLI\gh.exe` 전체 경로로 부른다 (PATH 갱신 전). git user는 `--local` 설정 끝

## 현재
| 항목 | 값 |
|---|---|
| 게임 | 6x6 격자 피하기 반응속도 게임, Godot 4.7.2 (gl_compatibility), 모바일 세로 우선 |
| 저장소 | `git init -b main`만 함. 커밋·원격·push 없음 |
| 연동 세팅 | `C:\AI\Game\setup\mobile_desktop_sync_SETUP.md` 3~5항 파일 작업 끝, 1·2·3·6·7·8항 남음 |
| 배포 | `.github/workflows/pages.yml`: PR은 웹 빌드 확인, main은 Pages 배포 (barichello/godot-ci:4.7.2) |

## 열린 항목
| ID | 내용 | 상태 |
|---|---|---|
| O-G03 | 저장소 이름·공개 여부·설명 답 받기 (기본: dodge-grid-game / public / "격자 위에서 날아오는 장애물을 피하는 반응속도 게임") → 저장소 생성·첫 커밋·push 승인 | ⏸️ |
| O-G05 | Godot 4.7.2 에디터 휴대용(win64 zip 86MB, MIT)을 `C:\AI\Game\tools\godot-4.7.2\`에 받기 승인. 템플릿(1.28GB)은 CI가 쓰므로 지금은 받지 않음 | ⏸️ |
| O-G06 | 첫 Actions 실행에서 pages.yml 확인, Pages Source=GitHub Actions, 폰에서 클라우드 세션 연결 확인 | ⏸️ |

## 주의
- ⚠️ Godot 기본 폰트에 한글 없음 → 웹 빌드에서 한글이 깨진다. 한글 UI는 폰트 에셋을 넣은 뒤에.
- ⚠️ 클라우드 세션엔 Godot가 없음 → 빌드 확인은 PR의 Actions로.
