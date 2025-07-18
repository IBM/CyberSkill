package utils.thejasonengine.com;

import io.vertx.core.Vertx;
import io.vertx.core.file.FileSystem;
import io.vertx.core.AsyncResult;
import io.vertx.core.Handler;

public class FolderCopier {

  public static void copyFolder(Vertx vertx, String src, String dst, Handler<AsyncResult<Void>> handler) {
    FileSystem fs = vertx.fileSystem();

    // Step 1: Create destination directory (mkdirs)
    fs.mkdirs(dst, mkdirsRes -> {
      if (mkdirsRes.failed()) {
        handler.handle(mkdirsRes.mapEmpty());
        return;
      }

      // Step 2: Read source directory contents
      fs.readDir(src, readDirRes -> {
        if (readDirRes.failed()) {
          handler.handle(readDirRes.mapEmpty());
          return;
        }

        // If no files, complete immediately
        if (readDirRes.result().isEmpty()) {
          handler.handle(io.vertx.core.Future.succeededFuture());
          return;
        }

        // Step 3: Copy each file/subdirectory
        int total = readDirRes.result().size();
        int[] completed = {0};
        boolean[] failed = {false};

        for (String path : readDirRes.result()) {
          fs.props(path, propsRes -> {
            if (propsRes.failed()) {
              if (!failed[0]) {
                failed[0] = true;
                handler.handle(propsRes.mapEmpty());
              }
              return;
            }

            // Extract file/folder name from path
            String name = path.substring(path.lastIndexOf('/') + 1);
            String destPath = dst + "/" + name;

            if (propsRes.result().isDirectory()) {
              // Recursive copy for subdirectory
              copyFolder(vertx, path, destPath, copyRes -> {
                completed[0]++;
                if (copyRes.failed() && !failed[0]) {
                  failed[0] = true;
                  handler.handle(copyRes.mapEmpty());
                } else if (completed[0] == total && !failed[0]) {
                  handler.handle(io.vertx.core.Future.succeededFuture());
                }
              });
            } else {
              // Copy file
              fs.copy(path, destPath, copyRes -> {
                completed[0]++;
                if (copyRes.failed() && !failed[0]) {
                  failed[0] = true;
                  handler.handle(copyRes.mapEmpty());
                } else if (completed[0] == total && !failed[0]) {
                  handler.handle(io.vertx.core.Future.succeededFuture());
                }
              });
            }
          });
        }
      });
    });
  }
}
