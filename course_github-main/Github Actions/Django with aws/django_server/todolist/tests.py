from django.test import TestCase

from user.services import insert_user, get_user
from .models import Todo
from .services import insert_todo, select_todos, get_todo


class TodoServiceTest(TestCase):
    def setUp(self):
        # 매 테스트 전, 테스트용 사용자 1명을 미리 생성해 로그인해둔다
        insert_user(username="tester", password="password", email="tester@example.com")
        self.user = get_user(username="tester", password="password")

    def test_insert_todo_success(self):
        # 할 일을 등록하면 DB에 저장된다
        insert_todo(todo_name="장보기", user=self.user)
        self.assertTrue(
            Todo.objects.filter(user=self.user, todo_name="장보기").exists()
        )

    def test_insert_todo_duplicate_fails(self):
        # 같은 사용자가 동일한 이름의 할 일을 중복 등록하면 실패한다
        insert_todo(todo_name="장보기", user=self.user)
        with self.assertRaises(ValueError):
            insert_todo(todo_name="장보기", user=self.user)

    def test_select_todos_returns_only_user_todos(self):
        # 특정 사용자가 등록한 할 일 목록만 조회된다
        insert_todo(todo_name="장보기", user=self.user)
        insert_todo(todo_name="빨래하기", user=self.user)

        todos = select_todos(user=self.user)
        self.assertEqual(len(todos), 2)

    def test_get_todo_success(self):
        # id로 특정 할 일 1건을 조회할 수 있다
        insert_todo(todo_name="장보기", user=self.user)
        todo = Todo.objects.get(user=self.user, todo_name="장보기")

        found = get_todo(user=self.user, id=todo.id)
        self.assertEqual(found.todo_name, "장보기")
