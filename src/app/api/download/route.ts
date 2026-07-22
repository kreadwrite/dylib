import { NextRequest, NextResponse } from "next/server";
import { readFile } from "fs/promises";
import path from "path";

const DOWNLOAD_DIR = "/home/z/my-project/download";

const files: Record<string, string> = {
  "PXTikTok.dylib": path.join(DOWNLOAD_DIR, "PXTikTok.dylib"),
  "CydiaSubstrate.dylib": path.join(DOWNLOAD_DIR, "CydiaSubstrate.dylib"),
  "PXTikTok.plist": path.join(DOWNLOAD_DIR, "PXTikTok.plist"),
  "PXTikTok-latest.zip": path.join(DOWNLOAD_DIR, "PXTikTok-latest.zip"),
};

export async function GET(request: NextRequest) {
  const searchParams = request.nextUrl.searchParams;
  const filename = searchParams.get("file");

  if (!filename || !files[filename]) {
    return NextResponse.json({ error: "File not found", available: Object.keys(files) }, { status: 404 });
  }

  const filePath = files[filename];
  const data = await readFile(filePath);

  return new NextResponse(data, {
    headers: {
      "Content-Disposition": `attachment; filename="${filename}"`,
      "Content-Type": "application/octet-stream",
    },
  });
}
