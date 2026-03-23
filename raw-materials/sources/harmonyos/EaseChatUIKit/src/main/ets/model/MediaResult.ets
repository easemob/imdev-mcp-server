
export class MediaResult {
  photo?: PhotoResult
  video?: VideoResult
}

export class PhotoResult {
  uri: string = '';
  width?: number;
  height?: number;
}

export class VideoResult extends PhotoResult{
  duration?: number
}