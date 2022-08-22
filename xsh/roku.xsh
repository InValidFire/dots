def play_yt_video(url_string: str):
	# sources:
	# playing specific video: https://community.home-assistant.io/t/getting-youtube-video-id-to-cast-to-roku/119796
	# general Roku SDPP docs: https://developer.roku.com/docs/developer-program/debugging/external-control-api.md
	import urllib.parse
	url = urllib.parse.urlparse(url_string)
	qs = urllib.parse.parse_qs(url.query)
	curl -X POST @(f"{ROKU_IP}:8060/launch/837?contentID={qs['v'][0]}")

def load_roku_session():
    storage = lib.StorageRoot()
    session_file = storage.get_file("roku_session")
    $(source @(session_file.path))

def roku_main(args: list):
    load_roku_session()
    play_yt_video(args[0])