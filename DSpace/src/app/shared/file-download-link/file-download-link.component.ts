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
  openPDFWithoutToolbar(): void {
    if (!this.bitstreamHref) return;

    const url = this.bitstreamHref + '#toolbar=0&navpanes=0&scrollbar=0';

    const newWindow = window.open('', '_blank');
    if (newWindow) {
      newWindow.document.write(`
        <html>
          <head><title>Xem PDF</title></head>
          <body style="margin:0">
            <iframe src="${url}" style="width:100vw; height:100vh; border:none;"></iframe>
          </body>
        </html>
      `);
      newWindow.document.close();
    }
  }
}


