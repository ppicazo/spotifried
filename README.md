# spotifried

### Developing on spotifried
1. [Create spotify application](https://developer.spotify.com/my-applications/#!/applications)
2. Put the client id and secret in `.env`
3. [Create Slack Integration for 'Bot'](https://www.slack.com/apps/build/custom-integration)
4. Put the bot API key in `.env`
5. Create a public playlist in spotify to test with
6. Make that playlist collaborative
7. Get the playlist id and put it in `.env`
8. Make sure redis is running locally
9. Start the app up with `foreman start` (install foreman if you don't have it)
10. Authenticate with spotify (public playlist editing scope) at: http://localhost:5000/auth/spotify
11. Invite the bot to your slack channel
12. Post a spotify track link in that slack channel
13. Check the playlist (refresh might be needed) for the new track

### Deploying
(almost the same as development, but use new IDs, keys, etc and you need to set the env variables and redis env variable)
(also you can spin down the web dyno since it isn't used for anything other than spotify auth)