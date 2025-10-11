/**
 * @summary Commit Message에 대한 규칙을 정의합니다.
 * @see https://github.com/conventional-changelog/commitlint/tree/master/%40commitlint/config-conventional
 *
 * 아래는 Commit Message의 형식을 정의한 것입니다.
 * - Type(필수): Commit의 종류. commit을 할 때, type에 상응하는 이모지가 자동으로 붙습니다.
 *              (Feat, Fix, Style, Refactor, File, Design, Comment, Chore, Docs, Hotfix)
 * - Scope(선택): Commit의 범위. 기능, 함수, 페이지, API 등 자유롭게 선택할 수 있습니다.
 * - Subject(필수): Commit의 제목. 되도록 간결하게 작성하고, 명사형 어미로 끝나도록 합니다.
 * - Body(선택): Commit의 내용. 어떤 이유로, 어떻게 변경했는지 작성합니다.
 * - Footer(자동): Issue Tracker ID가 자동으로 삽입됩니다. Branch 이름이 issue<id>- 형식이어야 합니다.
 *
 * @example <type>(optional scope): <subject>
 * - ✨ Feat: 로그인 기능 추가
 * - ✨ Feat(login/SignUp): 회원가입 기능 추가
 * - 🐛 Fix(login): 로그인 기능 수정
 * - ⭐️ Style: 코드 포맷 변경`
 * - ♻️  Refactor(SignUp): 회원 가입 로직 개선
 * - 📁 File: 이미지 파일 추가
 * - 🎨 Design(login): 로그인 페이지 디자인 변경(퍼블리싱)
 * - 🏷 Comment: API 함수 주석 추가
 * - ✅ Test: 테스트 코드 추가
 * - 📝 Docs: README.md 업데이트
 * - 🚑 Hotfix: 세션 관련 버그 수정
 * - 🔥 Remove: 사용하지 않는 파일 제거
 * - 💚 Ci: 자동 배포 스크립트 변드
 * - 🔖 Release: 릴리즈 버전 1.0.3
 * - 🔧 Chore: 설정파일 수정
 */

/*
<type>(optional scope): <subject>

[optional body]

[optional footer(s)]
*/

const Configuration = {
  extends: ["git-commit-emoji"],
  rules: {
    //* Type
    "type-enum": [
      2,
      "always",
      [
        "✨ Feat",
        "🐛 Fix",
        "⭐️ Style",
        "♻️ Refactor",
        "📁 File",
        "🎨 Design",
        "🏷 Comment",
        "✅ Test",
        "📝 Docs",
        "🚑 Hotfix",
        "🔥 Remove",
        "💚 Ci",
        "🔖 Release",
        "🔧 Chore"
      ],
    ],
    "type-case": [2, "always", "start-case"],
    "type-empty": [2, "never"],

    //* Scope
    "scope-case": [2, "never", []],

    //* Subject
    "subject-full-stop": [2, "never", "."],
    "subject-exclamation-mark": [2, "never", "!"],
    "subject-case": [2, "never", []],
    "subject-empty": [2, "never"],

    //* Body & Footer
    "body-leading-blank": [1, "always"],
    "body-max-line-length": [2, "always", 100],
    "footer-leading-blank": [1, "always"],
    "footer-max-line-length": [2, "always", 100],
  },

  prompt: {},
  ignores: [
    (message: string) =>
      message.startsWith("Merge") ||
      message.startsWith("Revert") ||
      message.startsWith("Amend") ||
      message.startsWith("Reset") ||
      message.startsWith("Rebase") ||
      message.startsWith("Tag"),
  ],
};

module.exports = Configuration;
