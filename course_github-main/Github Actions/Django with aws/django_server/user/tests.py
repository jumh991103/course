from django.test import TestCase

from .models import CustomUser
from .services import insert_user, get_user


class UserServiceTest(TestCase):
    def setUp(self):
        # 매 테스트 전, 테스트용 사용자 1명을 미리 생성
        insert_user(username="tester", password="password", email="tester@example.com")

    def test_insert_user_success(self):
        # 정상적인 정보로 회원가입하면 DB에 사용자가 생성된다
        self.assertTrue(
            CustomUser.objects.filter(name="tester").exists()
        )

    def test_insert_user_short_password_fails(self):
        # 비밀번호가 5자 미만이면 가입에 실패한다
        with self.assertRaises(ValueError):
            insert_user(username="new_user", password="1234", email="new_user@example.com")

    def test_insert_user_invalid_email_fails(self):
        # 이메일 형식이 아니면 가입에 실패한다
        with self.assertRaises(ValueError):
            insert_user(username="new_user", password="password", email="not-an-email")

    def test_insert_user_duplicate_name_fails(self):
        # 이미 존재하는 사용자명으로는 가입에 실패한다
        with self.assertRaises(ValueError):
            insert_user(username="tester", password="password", email="another@example.com")

    def test_get_user_success(self):
        # 아이디/비밀번호가 일치하면 로그인에 성공한다
        user = get_user(username="tester", password="password")
        self.assertEqual(user.name, "tester")

    def test_get_user_wrong_password_fails(self):
        # 비밀번호가 틀리면 로그인에 실패한다
        with self.assertRaises(ValueError):
            get_user(username="tester", password="wrong-password")

    def test_get_user_not_found_fails(self):
        # 존재하지 않는 아이디면 로그인에 실패한다
        with self.assertRaises(ValueError):
            get_user(username="unknown", password="password")
