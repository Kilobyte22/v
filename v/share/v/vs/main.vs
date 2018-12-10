(block
    (defun quit! () {
        v.exit()
    })

    (defun numbers (value) {
        v.buf.lineNumbers = scope.lvars.value:toBool()
        v.buf:update()
    })

    (defun status (message) {
        v.buf:setStatus(scope.lvars.message:toString())
    })

    (defun tempStatus (message) {
        v.buf:setTempStatus(scope.lvars.message:toString())
    })

    (defun quit () {
        if v.buf.modified then
            v.buf:setTempStatus("File modified. Use :quit! to exit or :write to save changes")
        else
            v.exit()
        end
    })

    (alias q quit)
    (alias q! quit!)

    (defun write (file)
        (if :file
            { local ok, msg = v.save(scope.lvars.file:toString())
              if not ok then
                  v.buf:setTempStatus(msg)
              end }
            { local ok, msg = v.save()
              if not ok then
                  v.buf:setTempStatus(msg)
              end }))

    (alias w write)

    (defun wq (file)
        (block
            (write :file)
            (quit)))
)
