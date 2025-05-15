import { Component, Input, OnInit, OnDestroy } from '@angular/core';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { Bitstream } from '../../core/shared/bitstream.model';
import { Item } from '../../core/shared/item.model';

@Component({
  selector: 'ds-file-download-link',
  templateUrl: './file-download-link.component.html',
  styleUrls: ['./file-download-link.component.scss']
})
export class FileDownloadLinkComponent implements OnInit, OnDestroy {
  @Input() bitstream: Bitstream;
  @Input() cssClasses = '';
  @Input() isBlank = true;
  @Input() item: Item;
  @Input() enableRequestACopy = true;

  bitstreamHref: string;
  sanitizedUrl: SafeResourceUrl;
  isViewerVisible = false;

  constructor(private sanitizer: DomSanitizer) {}

  ngOnInit() {
    this.bitstreamHref = this.bitstream?._links?.content?.href || '';
  }

  showViewer(event: Event): void {
    event.preventDefault(); // Ngăn chuyển hướng mặc định
    if (!this.bitstreamHref) return;

    const viewerUrl = this.bitstreamHref + '#toolbar=0&navpanes=0&scrollbar=0';
    this.sanitizedUrl = this.sanitizer.bypassSecurityTrustResourceUrl(viewerUrl);
    this.isViewerVisible = true;

    // Gắn lệnh chặn phím và chuột
    document.addEventListener('keydown', this.blockShortcuts);
    document.addEventListener('contextmenu', this.blockRightClick);
  }

  blockShortcuts = (e: KeyboardEvent) => {
    const key = e.key.toLowerCase();
    if ((e.ctrlKey || e.metaKey) && (key === 'p' || key === 's')) {
      e.preventDefault();
      alert(`Chức năng này đã bị vô hiệu hóa`);
    }
  };

  blockRightClick = (e: MouseEvent) => {
    e.preventDefault();
    alert('Chuột phải bị khóa trên tài liệu này');
  };

  ngOnDestroy() {
    // Dọn dẹp khi component bị hủy
    document.removeEventListener('keydown', this.blockShortcuts);
    document.removeEventListener('contextmenu', this.blockRightClick);
  }
}
