# dodge-grid-game STATE (덮어쓰기)
> 갱신 2026-11-22 · 마지막 작업 C-261122-DG03 · 코드 DG
> gh 로그인됨(Zearonimo). 이 PC 세션에선 PATH 갱신 전이라 `C:\Program Files\GitHub CLI\gh.exe` 전체 경로로 부른다. git user는 `--local` 설정 끝

## 현재
| 항목 | 값 |
|---|---|
| 게임 | 6x6 격자 피하기 반응속도 게임, Godot 4.7.2 (gl_compatibility), 모바일 세로 우선. 지금은 격자만 그림 |
| 저장소 | https://github.com/Zearonimo/dodge-grid-game (public), 원격 origin, main 첫 커밋 push됨 |
| 진행 중 | 없음 (다음: 게임 기본 구조 만들기) |
| 배포 | ✅ Pages(GitHub Actions) 첫 배포 성공. 플레이 링크 https://zearonimo.github.io/dodge-grid-game/ |
| 연동 세팅 | `mobile_desktop_sync_SETUP.md` 1~6항 끝. 7·8항(폰 연결, 기기 간 pull 확인) 남음 |

## 열린 항목
| ID | 내용 | 상태 |
|---|---|---|
| O-G06 | 폰 브라우저에서 플레이 링크에 격자가 보이는지 (사용자 확인) | ⏸️ |
| O-G07 | 폰 Claude 앱에서 GitHub 연결 후 이 저장소로 클라우드 세션 열기, 한쪽 push → 다른 쪽 pull 확인 | ⏸️ |
| O-G05 | Godot 4.7.2 에디터 휴대용(win64 zip 86MB, MIT)을 `C:\AI\Game\tools\godot-4.7.2\`에 받기 승인. 템플릿(1.28GB)은 CI가 쓰므로 받지 않음 | ⏸️ |

## 주의
- ⚠️ Godot 기본 폰트에 한글 없음 → 웹 빌드에서 한글이 깨진다. 한글 UI는 폰트 에셋을 넣은 뒤에.
- ⚠️ 클라우드 세션엔 Godot가 없음 → 빌드 확인은 PR의 Actions로.
- ⚠️ Web 프리셋에서 모바일 텍스처 압축을 쓰면 project.godot에 `import_etc2_astc=true`가 있어야 한다 (E-DG01). CI의 `libfontconfig` ERROR 줄은 무해.
