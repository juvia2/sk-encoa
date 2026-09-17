# sk-encoa

기존 프로젝트 5개를 각각 독립된 폴더에 모았습니다. 각 폴더에는 원래 저장소의 파일과 Git 커밋 기록이 보존되어 있습니다.

| 폴더 | 내용 |
| --- | --- |
| `py-uv-workspace/` | Python, Jupyter Notebook, Streamlit 예제 |
| `mysql-workspace/` | MySQL SQL 파일 |
| `NLP-workspace/` | 자연어 처리 예제와 데이터 |
| `emotion_diary/` | 감정 일기 앱 |
| `mnist_cnn_model/` | MNIST CNN Streamlit 앱과 모델 |

프로젝트마다 의존성과 상대 경로가 다릅니다. 실행할 때는 **해당 폴더로 이동한 뒤** 그 폴더의 `README.md`, `pyproject.toml` 또는 `requirements.txt`에 맞춰 환경을 설치하세요. 예를 들어 `mnist_cnn_model` 앱은 그 폴더에서 `streamlit run streamlit_cnn_app.py`로 실행하면 `saved_models/` 경로를 찾을 수 있습니다. `emotion_diary`는 MySQL 연결 설정이 필요합니다.

이 통합 저장소의 `main` 브랜치는 다섯 원본 저장소의 `main` 커밋을 모두 포함합니다. 원본 저장소를 삭제하지 않고 유지하면 기존 링크도 계속 작동합니다.
