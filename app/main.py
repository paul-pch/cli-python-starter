import typer

app = typer.Typer()


@app.command()
def hello(name: str = "World") -> None:
    print(f"Hello {name}! Welcome to your Python CLI application.")


if __name__ == "__main__":
    app()
