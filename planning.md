# Video Processing Planning

## Current state
- After video uploaded then processing video with only a resolution

## Requirements

- Validate file types like MP4, ...
    - Define in model
- State management for processing video life cycle
    - User AASM for management
- Push video processing to background job
- Convert the video into three resolutions: `360p`, `720p`, `1080p`
- Extract thumbnails
- Able to retry a few times before makeing the video as Failed
- Show the reason for failure in `ActiveAdmin`
- Show thumbnails in `ActiveAdmin`

## Features

- Upload video
- Process video in background job
    - Process video into 3 resolutions
    - Extract thumbnail from video
- State management of video item
- Show playback & thumbnail on Admin page

## Upcoming updates

- [x] Update Video states from (pending, processing, completed, failed) to (init, uploaded, processing, done, failed)
- [x] Add validate types (MP4) before uploading video
- [x] Change status to uploaded after passed validate
- [x] Convert video into 3 resolutions: `360p`, `720p`, `1080p` and change status to done
- [x] Show video with all resolutions (`original`, `360p`, `720p`, `1080p`) in `ActiveAdmin` (1)
- [x] Change status to failed after retries several times
- [x] Add `:processing_metadata` attribute to `Video` model
- [x] Save error reason into `:processing_metadata` and display in `ActiveAdmin`
- [x] Extract thumbnails when processing video
- [x] Show thumbnails in `ActiveAdmin` (2)