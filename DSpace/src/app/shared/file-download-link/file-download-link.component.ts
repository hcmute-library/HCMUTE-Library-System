import { Component, Input, OnInit } from '@angular/core';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { Bitstream } from '../../core/shared/bitstream.model';
import { Item } from '../../core/shared/item.model';
import { PdfJsViewerModule } from 'ng2-pdfjs-viewer';


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
  safePdfSrc: SafeResourceUrl;
  isViewerVisible = false;

  constructor(private sanitizer: DomSanitizer) {}

  ngOnInit(): void {
    this.bitstreamHref = this.bitstream?._links?.content?.href || '';
  }

  showPdfViewer(event: Event): void {
    event.preventDefault();
    if (this.bitstreamHref) {
      this.safePdfSrc = this.sanitizer.bypassSecurityTrustResourceUrl(this.bitstreamHref);
      this.isViewerVisible = true;
    }
  }
}
