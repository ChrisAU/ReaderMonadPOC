// Generated using Sourcery 0.16.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT





extension DeleteError {
    public enum prism {
        public static let notDeletable = Prism<DeleteError, ()>(
            preview: { if case .notDeletable = $0 { return () } else { return nil } },
            review: { .notDeletable })
    }
}

public extension Prism where Part == DeleteError {
	var notDeletable: Prism<Whole, Void> {
		return self • DeleteError.prism.notDeletable
	}
}


extension FileIOError {
    public enum prism {
        public static let delete = Prism<FileIOError, DeleteError>(
            preview: { if case .delete(let value) = $0 { return value } else { return nil } },
            review: { (x1) in .delete(x1) })
        public static let read = Prism<FileIOError, ReadError>(
            preview: { if case .read(let value) = $0 { return value } else { return nil } },
            review: { (x1) in .read(x1) })
        public static let write = Prism<FileIOError, WriteError>(
            preview: { if case .write(let value) = $0 { return value } else { return nil } },
            review: { (x1) in .write(x1) })
    }
}

public extension Prism where Part == FileIOError {
	var delete: Prism<Whole, DeleteError> {
		return self • FileIOError.prism.delete
	}
	var read: Prism<Whole, ReadError> {
		return self • FileIOError.prism.read
	}
	var write: Prism<Whole, WriteError> {
		return self • FileIOError.prism.write
	}
}


extension ReadError {
    public enum prism {
        public static let notFound = Prism<ReadError, ()>(
            preview: { if case .notFound = $0 { return () } else { return nil } },
            review: { .notFound })
    }
}

public extension Prism where Part == ReadError {
	var notFound: Prism<Whole, Void> {
		return self • ReadError.prism.notFound
	}
}


extension Result {
    public enum prism {
		public static var success: Prism<Result, T> {
			return .init(
				preview: { if case .success(let value) = $0 { return value } else { return nil } },
				review: { (x1) in .success(x1) })
		}
		public static var failure: Prism<Result, E> {
			return .init(
				preview: { if case .failure(let value) = $0 { return value } else { return nil } },
				review: { (x1) in .failure(x1) })
		}
    }
}



extension Try {
    public enum prism {
		public static var success: Prism<Try, T> {
			return .init(
				preview: { if case .success(let value) = $0 { return value } else { return nil } },
				review: { (x1) in .success(x1) })
		}
		public static var failure: Prism<Try, Error> {
			return .init(
				preview: { if case .failure(let value) = $0 { return value } else { return nil } },
				review: { (x1) in .failure(x1) })
		}
    }
}



extension WorldError {
    public enum prism {
        public static let database = Prism<WorldError, FileIOError>(
            preview: { if case .database(let value) = $0 { return value } else { return nil } },
            review: { (x1) in .database(x1) })
        public static let disk = Prism<WorldError, FileIOError>(
            preview: { if case .disk(let value) = $0 { return value } else { return nil } },
            review: { (x1) in .disk(x1) })
        public static let download = Prism<WorldError, DownloadError>(
            preview: { if case .download(let value) = $0 { return value } else { return nil } },
            review: { (x1) in .download(x1) })
    }
}

public extension Prism where Part == WorldError {
	var database: Prism<Whole, FileIOError> {
		return self • WorldError.prism.database
	}
	var disk: Prism<Whole, FileIOError> {
		return self • WorldError.prism.disk
	}
	var download: Prism<Whole, DownloadError> {
		return self • WorldError.prism.download
	}
}


extension WriteError {
    public enum prism {
        public static let notWritable = Prism<WriteError, ()>(
            preview: { if case .notWritable = $0 { return () } else { return nil } },
            review: { .notWritable })
    }
}

public extension Prism where Part == WriteError {
	var notWritable: Prism<Whole, Void> {
		return self • WriteError.prism.notWritable
	}
}

