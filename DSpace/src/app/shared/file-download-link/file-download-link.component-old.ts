import { Component, Input, OnInit } from '@angular/core';
import { Bitstream } from '../../core/shared/bitstream.model';
import { Item } from '../../core/shared/item.model';

@Component({
  selector: 'ds-file-download-link',
  templateUrl: './file-download-link.component.html',
  styleUrls: ['./file-download-link.component.scss']
})
export class FileDownloadLinkComponent implements OnInit {
  @Input() bitstream: Bitstream;
  @Input() cssClasses = '';
  @Input() isBlank = true;
  @Input() item: Item;
  @Input() enableRequestACopy = true;
  
  bitstreamHref: string;

  ngOnInit() {
    // Lấy link trực tiếp tới nội dung file (PDF, image, v.v.)
    this.bitstreamHref = this.bitstream?._links?.content?.href || '';
  }
  /**openPDFWithoutToolbar(): void {
    if (!this.bitstreamHref) return;

    const url = this.bitstreamHref + '#toolbar=0&navpanes=0&scrollbar=0';
    window.open(url, '_blank');
  }**/
  openPDFWithoutToolbar(): void {
    if (!this.bitstreamHref) return;

    const safeURL = this.bitstreamHref + '#toolbar=0&navpanes=0&scrollbar=0';

    const viewerHTML = `
      <!DOCTYPE html>
      <html>
        <head>
          <title>PDF Viewer</title>
          <style>
            html, body {
              margin: 0;
              padding: 0;
              height: 100%;
              overflow: hidden;
            }
            iframe {
              width: 100%;
              height: 100%;
              border: none;
            }
          </style>
          <script>
            document.addEventListener('keydown', function (e) {
              // Chặn Ctrl+P hoặc Cmd+P
              if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'p') {
                e.preventDefault();
                alert('In ấn tài liệu này bị vô hiệu hóa!');
              }

              // Chặn Ctrl+S hoặc Cmd+S
              if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 's') {
                e.preventDefault();
                alert('Lưu tài liệu bị chặn!');
              }
            });

            // Có thể thêm: chặn chuột phải
            // document.addEventListener('contextmenu', function(e) {
            //   e.preventDefault();
            // });
          </script>
        </head>
        <body>
          <iframe src="${safeURL}"></iframe>
        </body>
      </html>
    `;

    const newWindow = window.open('', '_blank');
    if (newWindow) {
      newWindow.document.open();
      newWindow.document.write(viewerHTML);
      newWindow.document.close();
    }
  }
}
