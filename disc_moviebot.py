#this Python script runs a Discord addon which by using your Discord token can be added to the server and serve as simple movie database.
import discord
import random

bot = commands.Bot(command_prefix='/')

movies = []
watched_movies = []

@bot.event
async def on_ready():
    print(f'Logged in as {bot.user.name}')

@bot.command()
async def roll(ctx):
    if len(movies) == 0:
        await ctx.send("No movies in the list.")
    else:
        random_movie = random.choice(movies)
        await ctx.send(f"The randomly chosen movie is: {random_movie}")

@bot.command()
async def add(ctx, movie):
    movies.append(movie)
    await ctx.send(f"{movie} has been added to the movie list.")

@bot.command()
async def watched(ctx, movie):
    if movie in movies:
        movies.remove(movie)
        watched_movies.append(movie)
        await ctx.send(f"{movie} has been moved to the watched list.")
    else:
        await ctx.send(f"{movie} is not in the movie list.")

bot.run('YOUR_DISCORD_BOT_TOKEN')
