# Video Processing Planning

## Current state
- After video uploaded then processing video with only a resolution

## Requirements

- Validate file types like MP4, AVI,...
- State management for processing video life cycle
- Push video processing to background job
- Convert the video into three resolutions: `360p`, `720p`, `1080p`
- Extract thumbnails
- Able to retry a few times before makeing the video as Failed
- Show the reason for failure in `ActiveAdmin`
- Show thumbnails in `ActiveAdmin`

## Upcoming updates

- [x] Update Video states from (pending, processing, completed, failed) to (init, uploaded, processing, done, failed)
- [x] Add validate types (MP4) before uploading video
- [x] Change status to uploaded after passed validate
- [x] Convert video into 3 resolutions: `360p`, `720p`, `1080p` and change status to done
- [ ] Show video with all resolutions (`original`, `360p`, `720p`, `1080p`) in `ActiveAdmin` (1)
- [ ] Change status to failed after retries several times
- [ ] Add `:processing_error` attribute to `Video` model
- [ ] Save error reason into `:processing_error` and display in `ActiveAdmin`
- [ ] Extract thumbnails when processing video
- [ ] Show thumbnails in `ActiveAdmin` (2)