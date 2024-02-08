import MLKit
import Foundation

/*
      Utilizes the Google MLKit Translation model for on-device and offline use.
      Currently having issues with translation from non-latin languages to latin languages
      so probably will look into other alternatives until I somehow get support for
      the issue.
     
      Error:
      LiveTranslate(32938,0x30cc5c000) malloc: *** error for object 0x30cc5ae28: pointer being freed was not allocated
      LiveTranslate(32938,0x30cc5c000) malloc: *** set a breakpoint in malloc_error_break to debug
 */

public class MLKitLanguageTranslator: ObservableObject {

    var translatorToForeign: Translator
    var translatorToNative: Translator
    
    @Published var translation: String = ""
    @Published var ready: Bool = true

    init(native: Language, foreign: Language) {
        self.translatorToForeign = MLKitLanguageTranslator.setupTranslator(native: native, foreign: foreign)
        self.translatorToNative = MLKitLanguageTranslator.setupTranslator(native: foreign, foreign: native)
        
        downloadLanguage(language: native)
        downloadLanguage(language: foreign)
    }
    
    private static func setupTranslator(native: Language, foreign: Language) -> Translator {
        print("SOURCE: \(native.details.name), TARGET: \(foreign.details.name)")
        let options = TranslatorOptions(
            sourceLanguage: native.details.mlkitCodex,
            targetLanguage: foreign.details.mlkitCodex
        )
        return Translator.translator(options: options)
    }
    
    private func model(forLanguage: TranslateLanguage) -> TranslateRemoteModel {
        return TranslateRemoteModel.translateRemoteModel(language: forLanguage)
    }
    
    private func isLanguageDownloaded(language: Language) -> Bool {
        let model = self.model(forLanguage: language.details.mlkitCodex)
        return ModelManager.modelManager().isModelDownloaded(model)
    }
    
    private func downloadLanguage(language: Language) {
        if isLanguageDownloaded(language: language) {
            print("\(language.details.name) model is already downloaded.")
            return
        }
        let languageModel = self.model(forLanguage: language.details.mlkitCodex)
        ModelManager.modelManager().download(
            languageModel,
            conditions: ModelDownloadConditions(
                allowsCellularAccess: false,
                allowsBackgroundDownloading: true
            )
        )
    }

    public func translate(native: String, reverse: Bool = false, completion: @escaping () -> Void) {
        print("REVERSE: \(reverse)")
        
        let translator: Translator = reverse ? self.translatorToNative : self.translatorToForeign
        self.ready = false
        
        translator.translate(native) { [weak self] translatedText, error in
            guard let self = self else {return}
            
            guard error == nil, let translatedText = translatedText else { return }
            self.translation = translatedText
            print("Translation: \(self.translation)")
            self.ready = true
            completion()
        }
    }
}
