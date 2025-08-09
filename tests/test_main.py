from typer.testing import CliRunner

from app.main import app

runner = CliRunner()


def test_hello_command() -> None:
    result = runner.invoke(app, ["--name", "World"])
    assert result.exit_code == 0
    assert "Hello World! Welcome to your Python CLI application." in result.output


def test_hello_with_name() -> None:
    result = runner.invoke(app, ["--name", "Alice"])
    assert result.exit_code == 0
    assert "Hello Alice! Welcome to your Python CLI application." in result.output
