import pygame as pg
from moviepy import VideoFileClip

# Initialize Pygame
pg.init()

# Set up the pg window
screen_width, screen_height = 640, 480
screen = pg.display.set_mode((screen_width, screen_height))
pg.display.set_caption("VLC Media Player Clone with pg")

# Load the video file
video_path = "your_video.mp4"
clip = VideoFileClip(video_path)
videoLoaded=False
videoEnded=False
# Define a clock to control frame rate
clock = pg.time.Clock()



# Main loop to display video
running = True
paused=False
frames=[]

while running:
    for event in pg.event.get():
        if event.type == pg.QUIT:
            running = False
            break
        if event.type == pg.KEYDOWN:
            keys=pg.key.get_pressed()
            if keys[pg.K_a]:
                videoLoaded=True
                for frame in clip.iter_frames(fps=24, dtype="uint8"):
                    frames.append(frame)

         # Play audio in the background
                clip.audio.write_audiofile("temp_audio.mp3")  # Save the audio separately
                pg.mixer.init()
                pg.mixer.music.load("temp_audio.mp3")
                
    i=0


    while(i<len(frames) and videoLoaded):
        if(i==0):
            pg.mixer.music.play()
        for event in pg.event.get():
            if event.type == pg.QUIT:
                videoLoaded=False
                running=False
                break 
            if event.type == pg.KEYDOWN:
                keys=pg.key.get_pressed()
                if keys[pg.K_SPACE]:
                    pg.mixer.music.pause()
                    paused=not paused
        frame_surface = pg.surfarray.make_surface(frames[i].swapaxes(0, 1))
        screen.blit(pg.transform.scale(frame_surface, (screen_width, screen_height)), (0, 0))
        pg.display.update()
        
        if(not paused):
            i+=1
            pg.mixer.music.unpause()
        clock.tick(24) 
    videoLoaded=False
    videoEnded=True
    if(videoEnded):
        frames.clear()
        pg.mixer.music.unload()
    screen.fill("black")
    pg.display.flip()
      # Maintain ~24 FPS

pg.quit()

